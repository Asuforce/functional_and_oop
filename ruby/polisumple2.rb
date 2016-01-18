class Human
  def initialize(item)
    @name = item
  end

  def hello
    print "Hello, my name is #{@name}.\n"
  end
end

class Japanese < Human
  def hello
    print "よろしく、#{@name} です。\n"
  end
end

class Filipino < Human
  def hello
    print "Pagbati, ang pangalan ko ay #{@name}.\n"
  end
end

def whoareyou(who)
  puts ""
  who.hello
end

shun = Filipino.new("Shun")
itiki = Japanese.new("イチキ")

whoareyou(shun)
# -> Hello, ito ay Shun.
whoareyou(itiki)
# -> よろしく、イチキ です。
