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
    customer_options
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
      file.write('Account name: ' + acct_name + '\n')
      file.write('Account Balance: ' + opening_bal + '$\n')
      file.write('Account type: ' + acct_type + '\n')
      file.write('Account email: ' + acct_email + '\n')
      file.write('Account number: ' + acct_num + '\n')
    end
    home_page
  elsif staff_options == 'check account details'
    print("Please what's your account number: ")
    check_acct = gets.chomp
    # reading out saved file from customer.txt file
    File.open('customer.txt', 'r') do |file|
      puts file.read
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

root
