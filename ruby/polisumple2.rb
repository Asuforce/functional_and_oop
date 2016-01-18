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
    print "よろしく、#{@name} です。\n\n"
  end
end

class Filipino < Human
  def hello
    print "Pagbati, ang pangalan ko ay #{@name} b.\n"
  end
end

def whoareyou(who)
  puts ""
  who.hello
end

nishituji = Filipino.new("ニシツジ")
itiki = Japanese.new("イチキ")

whoareyou(nishituji)
# 初めましてニシツジと申します。
whoareyou(itiki)
# よろしく、イチキです。
