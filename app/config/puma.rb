plugin :appsignal

workers 2

threads 5, 5

port 4001

debug

shared_dir = "/tmp/shared"
pid_dir = "#{shared_dir}/pids"
Dir.mkdir(pid_dir) unless Dir.exist?(pid_dir)

# Default to production
environment "production"

# Set up socket location
# bind "unix:///#{shared_dir}/sockets/puma.sock"

# stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

pidfile "#{pid_dir}/puma.pid"
state_path "#{shared_dir}/puma.state"
# activate_control_app
