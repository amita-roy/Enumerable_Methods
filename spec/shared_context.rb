def before_context
  before(:context) do
    puts
    puts 'Here we go with test for #my_each method! 🚀'
    sleep 2
  end
end

def after_context(method_name)
  after(:context) do
    puts
    sleep 2
    puts "Now we will move to #{method_name} method for testing! 🚀"
    sleep 2
    puts
  end
end

def ending_after_context
  after(:context) do
    puts
    sleep 2
    puts 'We are all done!, Thanks for testing. 👍'
    sleep 2
    puts
  end
end
