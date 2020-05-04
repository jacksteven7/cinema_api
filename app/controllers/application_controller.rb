class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  DIGITS = {
    1000 => "M",
     900 => "CM", 500 => "D", 400 => "CD",  100 => "C",
      90 => "XC",  50 => "L",  40 => "XL",   10 => "X",
       9 => "IX",   5 => "V",   4 => "IV",    1 => "I"
  }
  
  def romanize(num)
    DIGITS.keys.each_with_object('') do |key, str|
      nbr, num = num.divmod(key)
      str << DIGITS[key]*nbr
    end
  end
end
