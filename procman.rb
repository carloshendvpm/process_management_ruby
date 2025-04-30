#!/usr/bin/env ruby
#
# ProcManRuby - Simple Process Manager
# This script allows you to manage processes on a Unix-like system.
# It provides functionality to list, pause, resume, and kill processes.
# It also logs actions to a file.
# 

LOG_FILE = 'procman.log'

def log_action(action, pid = nil)
  timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  log_message = "#{timestamp} - #{action}"
  log_message += " - PID: #{pid}" if pid
  File.open(LOG_FILE, 'a') do |log|
    log.puts(log_message)
  end
end

def process_exists?(pid)
  begin
    Process.getpgid(pid)
    true
  rescue Errno::ESRCH
    false
  end
end

def list_processes
  command = "ps -eo pid,user,%cpu,%mem,etime,state,comm"
  output = `#{command}`
  log_action("Listagem de processos")
  puts output
end

def pause_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("STOP", pid.to_i)
      puts "Paused process with PID #{pid}"
      log_action("Paused process", pid)
    rescue Errno::EPERM
      puts "Error: permission denied. Can't stop the process` #{pid}."
      log_action("Error pausing process (permission denied)", pid)
    rescue => e
      puts "Error while pausing the process #{pid}: #{e.message}"
      log_action("Error pausing process", pid)
    end
  else
    puts "Process with PID #{pid} does not exist."
    log_action("Error pausing process (not found)", pid)
  end
end

def resume_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("CONT", pid.to_i)
      puts "Resumed process with PID #{pid}"
      log_action("Resumed process", pid)
    rescue Errno::EPERM
      puts "Error: permission denied. Can't resume the process #{pid}."
      log_action("Error resuming process (permission denied)", pid)
    rescue => e
      puts "Error while resuming the process #{pid}: #{e.message}"
      log_action("Error resuming process", pid)
    end
  else
    puts "Process with PID #{pid} does not exist."
    log_action("Error resuming process (not found)", pid)
  end
end

def kill_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("TERM", pid.to_i)
      puts "Killed process with PID #{pid}"
      log_action("Killed process", pid)
    rescue Errno::EPERM
      puts "Error: permission denied. Can't kill the process #{pid}."
      log_action("Error killing process (permission denied)", pid)
    rescue => e
      puts "Error while killing the process #{pid}: #{e.message}"
      log_action("Error killing process", pid)
    end
  else
    puts "Process with PID #{pid} does not exist."
    log_action("Error killing process (not found)", pid)
  end
end

def show_process_info(pid)
  if process_exists?(pid.to_i)
    command = "ps -p #{pid} -o pid,user,%cpu,%mem,etime,state,comm"
    output = `#{command}`

    puts output
    log_action("Show process info", pid)
  else
    puts "Process with PID #{pid} does not exist."
    log_action("Error showing process info (not found)", pid)
  end
end

def show_help
  puts "Usage: procman.rb [command] [pid]"
  puts "Commands:"
  puts "  list         List all processes"
  puts "  pause        Pause a process"
  puts "  resume       Resume a process"
  puts "  kill         Kill a process"
  puts "  help         Show this help message"
  puts "Examples:"
  puts "  procman.rb list"
  puts "  procman.rb pause 1234"
  puts "  procman.rb resume 1234"
  puts "  procman.rb kill 1234"
end

if ARGV.empty? || ARGV[0] == 'help'
  show_help
elsif ARGV[0] == 'list'
  list_processes
elsif ARGV[0] == 'pause' && ARGV[1]
  pause_process(ARGV[1])
elsif ARGV[0] == 'resume' && ARGV[1]
  continue_process(ARGV[1])
elsif ARGV[0] == 'kill' && ARGV[1]
  kill_process(ARGV[1])
else
  puts "Command not found."
  show_help
end
