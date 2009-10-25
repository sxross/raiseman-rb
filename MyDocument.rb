#
# MyDocument.rb
# RaiseManRb
#
# Created by Steve Ross on 10/22/09.
# Copyright nPhoto/Calico Web Development 2009. All rights reserved.
#

class MyDocument < NSDocument
  attr_accessor :employees, :tableView
  
  def init
    NSLog('initializing document')
    @employees ||= []
    NSLog("employees: #{@employees}")
    super
  end
  
  ########## Undo support ##########
  def insertObject(p, inEmployeesAtIndex:index)
    NSLog("adding #{p} to #{employees}")
    undo = @undoManager
    undo.prepareWithInvocationTarget(self, removeObjectFromEmployeesAtIndex:index)
    if !undo.isUndoing
      undo.setActionName("Insert Person")
    end
    employees.insertObject(p, atIndex:index)
  end
    
  def removeObject(p, fromEmployeesAtIndex:index)
    NSLog("removing #{p} from #{employees}")
    undo = self.undoManager
    undo.prepareWithInvocationTarget(self, addObject(p, inEmployeesAtIndex:index))
    if !undo.isUndoing
      undo.setActionName("Delete Person")
    end
    employees.removeObject(p, atIndex:index)
  end
  ########## /Undo support ##########
  
  def createEmployee(sender)
    NSLog("create employee")
    w = tableView.window
    puts "window is #{w}"
    editingEnded = w.makeFirstResponder(w)
    if !editingEnded
      NSLog("Unable to end editing")
      return
    end
    
    undo = @undoManager
    if undo.groupingLevel
      undo.endUndoGrouping
      undo.beginUndoGrouping
    end
    
    p = employeeController.newObject
    employeeController.addObject(p)
    employeeController.rearrangeObjects
    a = employeeController.arrangedObjects
    
    row = a.indexOfObjectIdenticalTo(p)
    NSLog("starting edit of #{p} in row #{row}")
    
    tableView.editColumn(0, row:row, withEvent:nil, select:true)
  end

	# Name of nib containing document window
	def windowNibName
		'MyDocument'
	end
	
	# Document data representation for saving (return NSData)
	def dataOfType(type, error:outError)
		outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
		nil
	end

	# Read document from data (return non-nil on success)
	def readFromData(data, ofType:type, error:outError)
		outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
		nil
	end

	# Return lowercase 'untitled', to comply with HIG
	def displayName
		fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
	end

end
