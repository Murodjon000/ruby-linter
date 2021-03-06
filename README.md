# Ruby Capstone Project - Ruby Linter🚀

# The Build
The custom Ruby linter currently checks/detects for the following errors/warnings.
- check for trailing spaces
- check for wrong indentation
- check for missing/unexpected tags i.e. '( )', '[ ]', and '{ }'
- check missing/unexpected end
- check empty line error

> Below are demonstrations of good and bad code for the above cases. I will use the pipe '|' symbol to indicate cursor position where necessary.

## Indentation Error Check
~~~ruby
# Good Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
end

# Bad Code

class Board
  def initialize(player, board)
    @player = player
      @board = board
  end
end
~~~

## Trailing spaces
> note where the cursor(|) is on the bad code 
~~~ruby
# Good Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
end

# Bad Code

class Board
  def initialize(player, board)  |
    @player = player
    @board = board
  end
end
~~~

## Missing/Unexpected Tag
~~~ruby
# Good Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
end

# Bad Code

class Board
  def initialize(player, board
    @player = player
    @board = [[board]
  end
end
~~~

## Missing/unexpected end
~~~ruby
# Good Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
end

# Bad Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
  end
end
~~~

## Empty line error
~~~ruby
# Good Code

class Board
  def initialize(player, board)
    @player = player
    @board = board
  end
end

# Bad Code

class Board
  def initialize(player, board)

    @player = player
    @board = board
  end
end
~~~


## Built With
- Ruby
- RSpec for Ruby Testing


# Getting Started

To get a local copy of the repository please run the following commands on your terminal:

```
$ cd <folder>
```

```
$ git clone https://github.com/Murodjon000/ruby-linter.git
```

**To check for errors on a file:** 

~~~bash
$ bin/main app.rb
~~~

## How to Test
1. Clone the repo to your local folder
2. cd into the folder
3. install gems by bundle install
4. Run rspec .
5. 6 examples, 0 failures will be output.

​
## Contributing
​
Contributions, issues, and feature requests are welcome!
Feel free to check the [issues page](../../issues).
​
## Prerequisites

Ruby,Text editor,Github profile and Git.


## Author

👤 **Murodjon000**

- GitHub: [@Murodjon000](https://github.com/Murodjon000)
- Twitter: [@Murodjon](https://twitter.com/Murodjo91836152)
- LinkedIn: [murodjon-tursunpulatov](https://www.linkedin.com/in/murodjon-tursunpulatov-5189481b3/)


## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the issues page.

Show your support

Give a ⭐️ if you like this project!


## Acknowledgments

- Project inspired by [Microverse](https://www.microverse.org)