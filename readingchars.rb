# read a character without pressing enter and without printing to the screen
def read_char
  begin
    # save previous state of stty
    old_state = `stty -g`
    # disable echoing and enable raw (not having to press enter)
    system "stty raw -echo"
    c = STDIN.getc.chr
    # gather next two characters of special keys
    if(c=="\e")
      extra_thread = Thread.new{
        c = c + STDIN.getc.chr
        c = c + STDIN.getc.chr
      }
      # wait just long enough for special keys to get swallowed
      extra_thread.join(0.00001)
      # kill thread so not-so-long special keys don't wait on getc
      extra_thread.kill
    end
  rescue => ex
    puts "#{ex.class}: #{ex.message}"
    puts ex.backtrace
  ensure
    # restore previous state of stty
    system "stty #{old_state}"
  end
  return c
end

def show_single_key
    c = read_char
	case c
	when " "
	  puts "SPACE"
	when "\t"
	  puts "TAB"
	when "\r"
	  puts "RETURN"
	when "\n"
	  puts "LINE FEED"
	when "\e"
	  puts "ESCAPE"
	when "\e[A"
	  puts "UP ARROW"
	when "\e[B"
	  puts "DOWN ARROW"
	when "\e[C"
	  puts "RIGHT ARROW"
	when "\e[D"
	  puts "LEFT ARROW"
	when "\177"
	  puts "BACKSPACE"
	when "\004"
	  puts "DELETE"
	when /^.$/
	  puts "SINGLE CHAR HIT: #{c.inspect}"
	else
	  puts "SOMETHING ELSE: #{c.inspect}"
	end
end

if __FILE__ == $PROGRAM_NAME
  show_single_key while(true)
end
