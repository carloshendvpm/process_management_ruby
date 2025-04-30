#!/usr/bin/env ruby

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
  puts output
end

def pause_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("STOP", pid.to_i)
      puts "Paused process with PID #{pid}"
    rescue Errno::EPERM
      puts "Error: permission denied. Can't stop the process` #{pid}."
    rescue => e
      puts "Error while pausing the process #{pid}: #{e.message}"
    end
  else
    puts "Process with PID #{pid} does not exist."
  end
end

def resume_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("CONT", pid.to_i)
      puts "Resumed process with PID #{pid}"
    rescue Errno::EPERM
      puts "Error: permission denied. Can't resume the process` #{pid}."
    rescue => e
      puts "Error while resuming the process #{pid}: #{e.message}"
    end
  else
    puts "Process with PID #{pid} does not exist."
  end
end

def kill_process(pid)
  if process_exists?(pid.to_i)
    begin
      Process.kill("TERM", pid.to_i)
      puts "Killed process with PID #{pid}"
    rescue Errno::EPERM
      puts "Error: permission denied. Can't kill the process` #{pid}."
    rescue => e
      puts "Error while killing the process #{pid}: #{e.message}"
    end
  else
    puts "Process with PID #{pid} does not exist."
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

