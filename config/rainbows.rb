working_directory `pwd -L`.chomp

# paths and things
socket_path = '/tmp/rainbows.sock'
pid_path    = 'tmp/pids/rainbows.pid'
err_path    = 'log/rainbows.error.log'
out_path    = 'log/rainbows.out.log'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 2

# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen socket_path, backlog: 64
listen "127.0.0.1:3000"

daemonize = true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid pid_path

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path err_path
stdout_path out_path

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  Redis.current.client.disconnect
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  Redis.current = Redis.new
end

# rainbows config
Rainbows! do
  use :ThreadPool
  worker_connections 16
  client_max_body_size nil
end
