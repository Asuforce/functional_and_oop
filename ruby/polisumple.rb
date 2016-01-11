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

nishituji = Person.new("西辻　スン")
itiki = Friend.new("イチジ")

whoareyou(nishituji)
whoareyou(itiki)
