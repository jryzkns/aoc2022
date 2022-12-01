maxCalories = -1
inventoryCount = 0
File.open( "input" ).each_line do | line |
    if line == ""
        maxCalories = Math.max( maxCalories, inventoryCount )
        inventoryCount = 0
    else
        calorieCount = line.to_i
        inventoryCount += calorieCount
    end
end

puts maxCalories
