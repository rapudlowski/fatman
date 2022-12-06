##### save as game_classes.rb

## Cells
class Cell
    attr_accessor :x
    attr_accessor :y
    attr_accessor :picture
    attr_accessor :walkable
    attr_accessor :has_fatman
    attr_accessor :has_food
    attr_accessor :has_enemy

    def initialize
        @picture = "  "
        @walkable = true
        @has_fatman = false
        @has_food = false
        @has_enemy = false
    end

    def get_food(food)
        @has_food = true
        @picture = food.picture
    end

    def lose_food
        @has_food = false
        @picture = "  "
    end

    def get_fatman(fatman)
        @has_fatman = true
        @picture = fatman.picture
    end

    def lose_fatman(fatman)
        @has_fatman = false
        @picture = "  "
    end

    def get_enemy(enemy)
        @has_enemy = true
        @walkable = false
        @picture = enemy.picture
    end

    def lose_enemy(enemy)
        @has_enemy = false
        @walkable = true
        @picture = "  "
    end

end

# Walls
class Wall < Cell
    def initialize
        @picture = "▓▓"
        @walkable = false
    end
end

# Traps

#class Trap < Cell

class Entity < Cell
    attr_accessor :size
    attr_accessor :pictures
    attr_accessor :lifespan
    attr_accessor :steps
end

# Fatman
class Fatman < Entity
    def initialize
        
        @pictures = [". ", "° ", "o ",  "O ", "@ "]
        @size = 1
        @picture = pictures[size]
    end

    def bigger
        if self.size < 5
            self.size += 1
        else
            self.size = 4
        end
        self.picture = self.pictures[self.size]
    end

    def smaller
        if self.size > 0
            self.size -= 1
        end
        self.picture = self.pictures[self.size]
    end

end



# Food
class Food < Entity
    def initialize
        @picture = Rainbow("ò ").green.bright
        @walkable = true
        @lifespan = 5
        @steps = 0
    end

end

# Enemy

class Enemy < Entity
    def initialize
        @picture = Rainbow("X ").red.bright
        @walkable = false
        @lifespan = 5
        @steps = 0
    end
end
