def root
  require 'json'
  puts("what would you like to do? Enter 1 or 2 to choose
      1. Staff login
      2. Customer login
      3. Close App: ")
  login_page = gets.chomp
  if login_page == '1'
    puts('Please input your username: ')
    username = gets.chomp
    puts('Please input your password: ')
    password = gets.chomp
    # opening staff.txt file to verify user input
    file = File.open('staff.txt', 'r')
    staff_details = JSON.load(file)
    if username == (staff_details['Staff1']['username']) && password == (
       staff_details['Staff1']['password']) || \
       username == (staff_details['Staff2']['username']) && password == (
       staff_details['Staff2']['password'])
      puts('Login Successful')
      staff_home_page
    else
      puts('Incorrect username or password')
      root
    end

  elsif login_page == '2'
    puts('What would you like to do: Enter 1 or 2 to choose
      1. Create an account pin
      2. Login')
    options = gets.chomp
    if options == '1'
      create_customer_pin
    elsif options == '2'

    else
      puts('Invalid entry')
      root
    end

  elsif login_page == '3'
    exit
  else
    puts('Invalid entry')
    # recalling the root method after an invalid entry
    root
  end
end

# creating a method for staff options after a successful login
def staff_home_page
  require 'json'

  puts("What would you like to do? Enter 1, 2 or 3 to choose
      1. Create new bank account
      2. Check Account Details
      3. Logout")
  staff_options = gets.chomp
  if staff_options == '1'
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
    # creating dictionaries to save in the customer.txt file
    overall_data = {}
    banking_details = {
      'Account name': acct_name, 'Opening Balance': opening_bal + '$',
      'Account type': acct_type, 'Account email': acct_email
    }
    overall_data[acct_num] = banking_details
    # check if customer.txt is empty by doing this, the essence of this is to enable the smooth reading of text from the file.
    if File.zero?('customer.txt')
      File.open('customer.txt', 'w') do |f|
        JSON.dump(overall_data, f)
      end
    else
      # i.e. if the customer.txt is not empty
      File.open('customer.txt') do |f_obj|
        overall_data = JSON.load(f_obj)
        # Then append the present user details
        overall_data[acct_num] = banking_details
      end
      # Then open the customer file in write mode and dump the overall_data to it
      File.open('customer.txt', 'w') do |fil|
        JSON.dump(overall_data, fil)
      end
    end
    staff_home_page
  elsif staff_options == '2'
    require 'json'
    print('Enter account number to check: ')
    check_acct = gets.chomp
    # reading out saved file from customer.txt file
    f_obj = File.open('customer.txt')
    data = JSON.load(f_obj)
    if data.key?(check_acct)
      puts("\n\tAccount Found ! See details below;")
      data[check_acct].each do |key, value|
        puts key.to_s + ' : ' + value
      end
      staff_home_page
    else
      print('Account does not exist! You can register a new one if you wish. Choose by entering 1 below')
    end
    staff_home_page
  elsif staff_options == '3'
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
        root

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
