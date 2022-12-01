maxCalories = -1
inventoryCount = 0
inventories = Set(Int64).new
File.open( "input" ).each_line do | line |
    if line == ""
        maxCalories = Math.max( maxCalories, inventoryCount )
        inventories << inventoryCount
        inventoryCount = 0
    else
        calorieCount = line.to_i
        inventoryCount += calorieCount
    end
end

top3CalorieSum = 0
3.times do
    top3CalorieSum += inventories.max
    inventories.delete inventories.max
end

puts top3CalorieSum
