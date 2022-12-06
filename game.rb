require 'io/console'
require './game_classes'
require 'rainbow/refinement'




system('clear') # mac
system('cls') # windows

loop_main = true
while loop_main == true
    ################
    # SETUP LOOP   #
    ################
    loop_setup = true
    while loop_setup == true
        
        # make a grid that's 15x15

        #size
        s = 15
        grid = Array.new(s) { Array.new(s) { Cell.new } }
        grid.each do |row|
            row.each do |cell|
                cell.x = row
                cell.y = cell
                #print cell.picture
            end
            #puts
        end

        #######  making walls
        #outer walls
        (0...s).each do |i|
            grid[i][0] = Wall.new
            grid[i][s-1] = Wall.new
        end
        (1...s).each do |i|
            grid[0][i] = Wall.new  
            grid[s-1][i] = Wall.new
        end

        ###### place Fatman

        fatman = Fatman.new
        randx = rand(1..(s-2))
        randy = rand(1..(s-2))
        placed = false
        if (grid[randx][randy].walkable == true) && (placed == false)
            grid[randx][randy].get_fatman(fatman)
            fatman.x, fatman.y = randx, randy
            placed = true
        end



        ########## place food

        foods_count = 2
        foods = Array.new(foods_count) {Food.new}
        foods.each do |f|
            placed= false
            while (grid[randx][randy].has_food != true) && (grid[randx][randy].walkable == true) && (placed == false)
                randx_f = rand(1..(s-2))
                randy_f = rand(1..(s-2))
                grid[randx_f][randy_f].get_food(f)
                f.x = randx_f
                f.y = randy_f
                placed = true
            end
        end

        ########### place enemy
        enemy_count = 3
        enemies = Array.new(enemy_count) {Enemy.new}
        enemies.each do |e|
            placed= false
            while (grid[randx][randy].has_enemy != true) && (grid[randx][randy].walkable == true) && (placed == false)
                randx_e = rand(1..(s-2))
                randy_e = rand(1..(s-2))
                grid[randx_e][randy_e].get_enemy(e)
                e.x = randx_e
                e.y = randy_e
                placed = true
            end
        end
        loop_setup = false
    end # END SETUP LOOP

    ##################
    #   GAME LOOP    #
    ##################
    loop_game = true
    # show grid
    while loop_game == true
        grid.each do |row|
            row.each do |cell|
                print cell.picture
            end
            puts
        end

        # user interface
        puts " SIZE: #{fatman.size} | WASD to move | Collect #{Rainbow("ò FOOD").green.bright} | Avoid #{Rainbow("X ENEMIES").red.bright}} | q to quit "

        # get a character without pressing enter.
        kb = STDIN.getch

        # just do them both!!!! (to clear the screen)
        system('clear') # mac
        system('cls') # windows
        next_grid = grid.clone

        
        case kb ########### MOVE FATMAN #############
        when "w" # move up
            if grid[fatman.x-1][fatman.y].walkable == true
                grid[fatman.x][fatman.y].lose_fatman(fatman)
                grid[fatman.x-1][fatman.y].get_fatman(fatman)
                fatman.x -= 1
            end
        when "s" # move down
            if grid[fatman.x+1][fatman.y].walkable == true
                grid[fatman.x][fatman.y].lose_fatman(fatman)
                grid[fatman.x+1][fatman.y].get_fatman(fatman)
                fatman.x += 1
            end
        when "a" # move left
            if grid[fatman.x][fatman.y-1].walkable == true
                grid[fatman.x][fatman.y].lose_fatman(fatman)
                grid[fatman.x][fatman.y-1].get_fatman(fatman)
                fatman.y -= 1
            end
        when "d" # move right
            if grid[fatman.x][fatman.y+1].walkable == true
                grid[fatman.x][fatman.y].lose_fatman(fatman)
                grid[fatman.x][fatman.y+1].get_fatman(fatman)
                fatman.y += 1
            end
        when "q"
            loop_main = false
            break
            
        end ############# END MOVE FATMAN #############

    
        foods.each do |f| ############# MOVE FOOD ################
      
            food_dir = ["w", "a", "s", "d"].sample
            case food_dir
            when "w" # move up
                if grid[f.x-1][f.y].walkable == true
                    grid[f.x][f.y].lose_food
                    grid[f.x-1][f.y].get_food(f)
                    f.x -= 1
                end
            when "s" # move down
                if grid[f.x+1][f.y].walkable == true
                    grid[f.x][f.y].lose_food
                    grid[f.x+1][f.y].get_food(f)
                    f.x += 1
                end
            when "a" # move left
                if grid[f.x][f.y-1].walkable == true
                    grid[f.x][f.y].lose_food
                    grid[f.x][f.y-1].get_food(f)
                    f.y -= 1
                end
            when "d" # move right
                if grid[f.x][f.y+1].walkable == true
                    grid[f.x][f.y].lose_food
                    grid[f.x][f.y+1].get_food(f)
                    f.y += 1
                end
            end
            
            if grid[fatman.x][fatman.y].has_food == true
                if fatman.size < 4
                    fatman.bigger
                else
                    loop_game = false
                    puts Rainbow("YOU WIN").yellow.bright
                    gets
                    system('clear') # mac
                    system('cls') # windows
                grid[fatman.x][fatman.y].lose_food
            end
        end ############### END MOVE FOOD ######################
   
        enemies.each do |e| ############# MOVE ENEMY ####################
            if e.steps <= e.lifespan
                enemy_dir = ["w", "a", "s", "d"].sample
                case enemy_dir
                when "w" # move up
                    if grid[e.x-1][e.y].walkable == true
                        grid[e.x][e.y].lose_enemy(e)
                        grid[e.x-1][e.y].get_enemy(e)
                        e.x -= 1
                    end
                when "s" # move down
                    if grid[e.x+1][e.y].walkable == true
                        grid[e.x][e.y].lose_enemy(e)
                        grid[e.x+1][e.y].get_enemy(e)
                        e.x += 1
                    end
                when "a" # move left
                    if grid[e.x][e.y-1].walkable == true
                        grid[e.x][e.y].lose_enemy(e)
                        grid[e.x][e.y-1].get_enemy(e)
                        e.y -= 1
                    end
                when "d" # move right
                    if grid[e.x][e.y+1].walkable == true
                        grid[e.x][e.y].lose_enemy(e)
                        grid[e.x][e.y+1].get_enemy(e)
                        e.y += 1
                    end
                end
                #e.steps += 1
            end

            if grid[fatman.x][fatman.y].has_enemy == true
                if fatman.size > 0
                    fatman.smaller
                else
                    loop_game = false
                    puts Rainbow("YOU LOSE").red.bright
                    gets
                end
                grid[fatman.x][fatman.y].lose_enemy(e)
            end
        end ############ END MOVE ENEMY ###########################
    end # loop_game
end # loop_main

end