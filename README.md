# Plugin manager for Vim with Pathogen
With this Ruby script you can easily install, update and remove Vim plugins in ~/.vim/bundle (Pathogen)

## Installation

Add this line to your application's Gemfile:

    gem 'vim_pathogen_plugin_manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vim_pathogen_plugin_manager

## Usage

Create file ~/.vim/bundle.list (example in this repository) and put there all plugins you want to install and maintain:

    # put this file in ~/.vim/  => ~/.vim/bundle.list
    https://github.com/tpope/vim-sensible.git
    https://github.com/scrooloose/nerdcommenter.git

Plugins on this list will be installed. Plugins already installed will be updated. If you want to remove a plugin, just delete it from file or comment it out and run remove task.

Now you can easily install, update or remove plugins by running:

Install:

    vim_pathogen_plugin_manager -i

Update:

    vim_pathogen_plugin_manager -u

Remove:

    vim_pathogen_plugin_manager -r

You can also use file in some other location with additional -p parameter:

    vim_pathogen_plugin_manager -i -p /some/other/location/bundle.list

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vim_pathogen_plugin_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
