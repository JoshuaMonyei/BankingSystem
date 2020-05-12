def root
  require 'json'
  puts("what would you like to do? Enter 1 or 2 to choose
      1. Staff login
      2. Customer login
      3. Close App: ")
  login_page = gets.chomp
  if login_page == '1'
    staff_login

  elsif login_page == '2'
    customer_options

  elsif login_page == '3'
    exit

  else
    puts('Invalid entry')
    # recalling the root method after an invalid entry
    root
  end
end

# function detailing staff login process
def staff_login
  print('Please input your staff username: ')
  username = gets.chomp
  print('Enter your password: ')
  password = gets.chomp
  # opening staff.txt file to verify user input
  file = File.open('staff.txt', 'r')
  staff_details = JSON.load(file)
  if username == (staff_details['Staff1']['username']) && password == (
     staff_details['Staff1']['password']) || \
     username == (staff_details['Staff2']['username']) && password == (
     staff_details['Staff2']['password'])
    puts("\tLogin Successful")
    staff_home_page
  else
    puts('Incorrect username or password')
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
    print(' Enter Account name: ')
    acct_name = gets.chomp
    print('Opening Balance: $')
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
      'Account name': acct_name, 'Account Balance': opening_bal.to_i,
      'Account type': acct_type, 'Account email': acct_email
    }
    overall_data[acct_num] = banking_details
    # checking if customer.txt is empty, the essence of this is to allow reading of text from the file.
    if File.zero?('customer.txt')
      File.open('customer.txt', 'w') do |f|
        JSON.dump(overall_data, f)
      end
    else
      # i.e. if the customer.txt is not empty, we load the past data to the dictionary then add present data to it.
      File.open('customer.txt') do |f_obj|
        overall_data = JSON.load(f_obj)
        # Then append the present user details
        overall_data[acct_num] = banking_details
      end
      # opening the customer.txt file in write mode to dump the overall_data to it.
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
      # printing out dictionary key and values stored with the account number.
      data[check_acct].each do |key, value|
        puts("\n" + key.to_s + ' : ' + value.to_s)
      end
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
    staff_home_page
  end
end

def customer_options
  puts('What would you like to do: Enter 1 or 2 to choose;
    1. Create an account pin
    2. Login
    3. Exit')
  options = gets.chomp
  if options == '1'
    create_customer_pin

  elsif options == '2'
    customer_login

  elsif options == '3'
    root

  else
    puts('Invalid entry')
    customer_options
  end
end

def create_customer_pin
  require 'json'
  print('If you have an account with us please enter your account number: ')
  customer_acct = gets.chomp
  # Checking to see customer input exist in the data base
  f_obj = File.open('customer.txt')
  data = JSON.load(f_obj)
  if data.key?(customer_acct)
    puts("\n\tAccount number is valid")
    print('Create an account pin: ')
    acct_pin = gets.chomp
    # checking only numbers were entered as input and the characters are between 4 - 6
    if acct_pin.to_i.to_s == acct_pin && acct_pin.length >= 4 && acct_pin.length <= 6
      customer_login_details = {}
      entry = { 'Account pin': acct_pin }
      customer_login_details[customer_acct] = entry
      # checking if customer_login.txt is empty, the essence of this is to enable access to file through the JSON module.
      if File.zero?('customer_login.txt')
        File.open('customer_login.txt', 'w') do |f|
          JSON.dump(customer_login_details, f)
        end
      else
        # i.e. if the customer-login.txt is not empty
        File.open('customer_login.txt') do |filn|
          customer_login_details = JSON.load(filn)
          # Then append the present user details
          customer_login_details[customer_acct] = entry
        end
        # Opening the customer_login file in write mode to dump the customer login details.
        File.open('customer_login.txt', 'w') do |fil|
          JSON.dump(customer_login_details, fil)
        end
      end
      customer_options

    else
      puts('Pin Should be between 4-6 digits')
      create_customer_pin
    end

  else
    puts('Invalid account number')
    create_customer_pin
  end
end

def customer_login
  require 'json'

  print('Please enter your Account Number: ')
  customer_acct = gets.chomp
  print('Enter Account Pin: ')
  acct_pin = gets.chomp
  f_obj = File.open('customer_login.txt')
  data = JSON.load(f_obj)
  login = true
  # verifying if inputed details are stored in the customer_login.txt file.
  if data.key?(customer_acct) && data[customer_acct]['Account pin'] == acct_pin
   puts("\n\tLogin Successful")
   while login == true
    puts("What would you like to do: Enter 1, 2 or 3 to choose
     1. Check Account Balance
     2. Make Deposit
     3. Withdrawals
     4. Logout")
    customer_login_options = gets.chomp
    if customer_login_options == '1'
     fil = File.open('customer.txt')
     customer_details = JSON.load(fil)
     puts("\n\tYour account balance is: $" + customer_details[customer_acct]['Account Balance'].to_s)
     puts("\n\t Thanks for banking with us, We at snbank value you alot!")
 
    elsif customer_login_options == '2'
     print('How much are you depositing: $')
     deposit = gets.chomp
     if deposit.to_i.to_s == deposit
      overall_data = {}
      File.open('customer.txt') do |f_obj|
       overall_data = JSON.load(f_obj)
       # Then append the present user details
       overall_data[customer_acct]['Account Balance'] += deposit.to_i
      end
      File.open('customer.txt', 'w') do |fil|
       JSON.dump(overall_data, fil)
      end
      puts("\n\t Transaction Successful")

     else
      puts('Invalid amount')
     end

    elsif customer_login_options == '3'
     print('How much are you withdrawing: $')
     withdrawal = gets.chomp
     # to confirm if input was valid i.e. numbers
     if withdrawal.to_i.to_s == withdrawal
      overall_data = {}
      File.open('customer.txt') do |f|
       overall_data = JSON.load(f)
       # Changing account details due to the recent transaction
       overall_data[customer_acct]['Account Balance'] -= withdrawal.to_i
      end
      File.open('customer.txt', 'w') do |filn|
       JSON.dump(overall_data, filn)
      end
      puts("\n\t Transaction Successful")
     else
       puts('Invalid amount')
     end

    elsif customer_login_options == '4'
     puts('Logout Successful')
     login = false
     root

    else
     puts('Invalid entry;')
    end
   end

  else
   puts('Wrong account number or password')
   customer_login
  end
end

root
