def root
  puts("what would you like to do?
      1. Staff login
      2. Customer login
      3. Close App: ")
  login_page = gets.chomp.downcase
  if login_page == 'staff login'
    puts('Please input your username: ')
    username = gets.chomp
    puts('Please input your password: ')
    password = gets.chomp
    # opening staff.txt file to verify user input
    File.open('staff.txt', 'r') do |file|
      if file.read.match(username && password)
        puts('Login successful')
        home_page
      else
        puts('Incorrect username or password')
        root
      end
    end
  elsif login_page == 'customer login'
    puts('What would you like to do:
      1. Create an account pin
      2. Login')
    options = gets.chomp.downcase
    if options == 'create an account pin'
      create_customer_pin
    elsif options == 'login'
  
    else
      puts('Invalid entry')
      root
    end
  
  elsif login_page == 'close app'
    exit
  else
    puts('Invalid entry')
    # recalling the root method after an invalid entry
    root
  end
end

# creating a method for staff options after a successful login
def home_page
  puts("What would you like to do?
      1. Create new bank account
      2. Check Account Details
      3. Logout")
  staff_options = gets.chomp.downcase
  if staff_options == 'create new bank account'
    print('Account name: ')
    acct_name = gets.chomp
    print('Opening Balance: ')
    opening_bal = gets.chomp
    print('Account type: ')
    acct_type = gets.chomp
    print('Account email: ')
    acct_email = gets.chomp
    # generating random number to use as acct number
    acct_num = 10.times.map { rand(0..9) }.join.to_s
    puts('Your account number is: ' + acct_num)
    # saving variables in the customer.txt file
    File.open('customer.txt', 'a') do |file|
      file.write('Account name: ' + acct_name + ' ')
      file.write('Account Balance: ' + opening_bal + ' ')
      file.write('Account type: ' + acct_type + ' ')
      file.write('Account email: ' + acct_email + ' ')
      file.write('Account number: ' + acct_num + "\n")
    end
    home_page
  elsif staff_options == 'check account details'
    print("Please what's your account number: ")
    check_acct = gets.chomp
    # reading out saved file from customer.txt file
    search = open('customer.txt', 'r')
    for lines in search
      if lines.include? check_acct
        print lines
      end
    end
    home_page
  elsif staff_options == 'logout'
    puts('Logout successful')
    # recalling the root method
    root
  else
    puts('Inavlid entry')
    # recalling the home page after an invalid entry among staff options
    home_page
  end
end

def create_customer_pin
  print('If you have an account with us please enter your account number: ')
  customer_acct = gets.chomp
  File.open('customer.txt', 'r') do |file|
    if file.read.include? customer_acct
      puts('Account number is Valid')
      print('Create an account pin: ')
      acct_pin = gets.chomp
      # checking only numbers were entered as input and the characters are between 4 - 6
      if acct_pin.to_i.to_s == acct_pin && acct_pin.length >= 4 && acct_pin.length <= 6
        puts(acct_pin)
        File.open('customer_login.txt', 'a') do |file|
          file.write('Account number: ' + customer_acct + ' ')
          file.write('Account Pin: ' + acct_pin + "\n")
        end

      else
        puts('Pin Should be between 4-6 digits')
        create_customer_pin
      end
    else
      puts('Invalid account number')
      create_customer_pin
    end
  end
end

root
