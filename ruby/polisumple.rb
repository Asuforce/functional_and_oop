class Person
  def initialize(item)
    @name = item
  end

  def hello
    print "初めまして#{@name}と申します。\n"
  end
end

class Friend < Person
  def hello
    print "よろしく、#{@name} です。"
  end
end

def whoareyou(who)
  who.hello
end

nishituji = Person.new("ニシツジ")
itiki = Friend.new("イチキ")

whoareyou(nishituji)
# 初めましてニシツジと申します。
whoareyou(itiki)
# よろしく、イチキです。
