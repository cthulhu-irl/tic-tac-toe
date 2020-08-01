#!/usr/bin/env -S ruby -w

WIN_SETS =
  [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # horizontals
    [0, 3, 6], [1, 4, 7], [2, 5, 8], # verticals
    [0, 4, 8], [2, 4, 6]             # diagonals
  ]

def print_board(board, w)
  return if board.empty?

  puts '+-----' * w + '+'

  0.upto(w-1) do |i|
    mid = board[(i*w)...(i*w+w)].join('  |  ')

    puts '|     ' * w +     '|'
    puts '|  '    + mid + '  |'
    puts '|     ' * w +     '|'
    puts '+-----' * w +     '+'
  end
end

def prompt_choice(board, player)
  loop do
    print "[#{player}] (choose from 1..9)> "
    choice = gets.chomp.to_i

    return choice-1 \
      if (1..9).include?(choice) && board[choice-1] == ' '

    puts '[!] some problem with your choice, try again...'
  end
end

def print_final_status(player, status)
  width = 50

  mid = {
    win:  " WINNER IS #{player} !!! ",
    lose: " #{player} IS LOOSER !!! ",
    draw: ' NO ONE WON, GO HOME !!! ',
    quit: ' GOOOOOOOD BYYYYYYYE !!! '
  }.fetch(status, ' [Unknown Status] ')

  row = '-' * width
  mid = mid.center(width, '-')

  puts '+' + row + '+'
  puts '|' + mid + '|'
  puts '+' + row + '+'
end

def board_check(board, player)
  WIN_SETS.each do |set|
    return :win if set.reduce(true) do |m, i|
      m && (board[i] == player)
    end
  end

  return :draw unless board.include?(' ')
end

def main
  players = ['X', 'O']
  board = [
    ' ', ' ', ' ',
    ' ', ' ', ' ',
    ' ', ' ', ' '
  ]

  count = 0
  loop do
    print_board(board, 3)

    player = players[count % 2]

    choice = prompt_choice(board, player)

    board[choice] = player

    status = board_check(board, player)

    return print_final_status(player, status) if status

    count += 1
  end
end

begin
  main
rescue Interrupt
  puts
  print_final_status(' ', :quit)
end
