# Person.rb
# RaiseManRb
#
# Created by Steve Ross on 10/22/09.
# Copyright 2009 nPhoto/Calico Web Development. All rights reserved.

framework "Foundation"

class Person
  attr_accessor :personName
  attr_accessor :expectedRaise
  
  def initialize
    NSLog('initializing person')
    @personName = 'New Person'
    @expectedRaise = 0.05
    self
  end
  
  def setNilValueForKey(key)
    if key == 'expectedRaise'
      @expectedRaise = 0.0
    else
      super
    end
  end
end