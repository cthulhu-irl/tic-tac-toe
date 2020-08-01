#!/usr/bin/env -S ruby -w

WIN_SETS =
  [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # horizontals
    [0, 3, 6], [1, 4, 7], [2, 5, 8], # verticals
    [0, 4, 8], [2, 4, 6]             # diagonals
  ].freeze

def make_focused_win_sets
  Array.new(9) do |i|
    sets = WIN_SETS.select { |set| set.include?(i) }
    sets.map { |set| set.select { |x| x != i } }
  end
end

FOCUSED_WIN_SETS = make_focused_win_sets.freeze

def print_board(board, w, h)
  return if board.empty?

  puts '+-----' * w + '+'

  (0...h).each do |i|
    mid = board[(i*w)...(i*w+w)].join('  |  ')

    puts '|     ' * w +     '|'
    puts '|  '    + mid + '  |'
    puts '|     ' * w +     '|'
    puts '+-----' * w +     '+'
  end
end

def prompt_choice(board, player, count)
  loop do
    print "[player: #{player}, count: #{count}] (choose from 1..9)> "
    choice = gets.chomp.to_i - 1

    return choice \
      if (0...9).include?(choice) && board[choice] == ' '

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

def board_check_win(board, player, choice)
  FOCUSED_WIN_SETS[choice].any? do |set|
    set.all? { |i| board[i] == player }
  end
end

def board_check(board, player, choice)
  return :win if board_check_win(board, player, choice)

  # trade off :|
  return :draw unless board.flatten.include?(' ')
end

def game_loop
  players = ['X', 'O']
  board = [
    ' ', ' ', ' ',
    ' ', ' ', ' ',
    ' ', ' ', ' '
  ]

  count = 0
  loop do
    print_board(board, 3, 3)

    player = players[count % 2]

    choice = prompt_choice(board, player, count+1)

    board[choice] = player

    status = board_check(board, player, choice)

    return print_final_status(player, status) if status

    count += 1
  end
end

begin
  game_loop
rescue Interrupt
  puts
  print_final_status(' ', :quit)
end
