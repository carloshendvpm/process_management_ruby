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
  pid = pid.to_i
  return false if pid <= 0

  begin
    # send signal 0 to check if the process exists
    Process.kill(0, pid)
    true
  rescue Errno::ESRCH
    false 
  rescue Errno::EPERM
    true 
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
    command = "ps -p #{pid} -o pid,user,%cpu,%mem,etime,state,args"
    output = `#{command}`

    if output.empty? || output.include?("ERROR")
      puts "Failed to retrieve information for PID #{pid}. It might be a kernel thread, zombie, or incompatible system."
      log_action("Error showing process info (no data)", pid)
    else
      puts output
      log_action("Show process info", pid)
    end
  else
    puts "Process with PID #{pid} does not exist."
    log_action("Error showing process info (not found)", pid)
  end
end

def interactive_mode
  loop do
    puts "ProcManRuby - Interactive Mode"
    puts "Enter a command (list, pause, resume, kill, info, exit):"
    command = STDIN.gets.chomp  # Changed here
    case command
    when 'list'
      list_processes
    when 'pause'
      puts "Enter PID to pause:"
      pid = STDIN.gets.chomp   # Changed here
      pause_process(pid)
    when 'resume'
      puts "Enter PID to resume:"
      pid = STDIN.gets.chomp   # Changed here
      resume_process(pid)
    when 'kill'
      puts "Enter PID to kill:"
      pid = STDIN.gets.chomp   # Changed here
      kill_process(pid)
    when 'info'
      puts "Enter PID to show info:"
      pid = STDIN.gets.chomp   # Changed here
      show_process_info(pid)
    when 'exit'
      puts "Exiting interactive mode."
      log_action("Exited interactive mode")
      break
    else
      puts "Unknown command."
      puts "Available commands: list, pause, resume, kill, info, exit"
    end
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
  resume_process(ARGV[1])
elsif ARGV[0] == 'kill' && ARGV[1]
  kill_process(ARGV[1])
elsif ARGV[0] == 'info' && ARGV[1]
  show_process_info(ARGV[1])
elsif ARGV[0] == 'interactive'
  log_action("Entered interactive mode")
  interactive_mode
else
  puts "Command not found."
  show_help
end
