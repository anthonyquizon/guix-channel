
## Setup
Git clone into dir and add the following to `~/.config/guix/channels.scm`:
```
(cons (channel
        (name 'anthonyquizon-packages)
        (url "file:///home/anthony/guix") ;;or use git url
        (branch "master"))
      %default-channels)
```

## Repl
`guix repl -L .`
eg command:. `,use (anthonyquizon packages base)


## Testing
* `guix build -L <GUIX_CHANNEL_PATH> <package>`
    * eg `guix build -L . dub`
* `guix --install-from-file=<file>`

## Updating channel
* Make sure to `git commit`. Channels updates are determined by git hash


## Troubleshooting
### Cannot find package when running `guix build -L . <package>`
This probably means that the package isnt building properly.
Check for syntax errors and such

### Missing packages after `guix pull`
Try `guix describe -f channels`. It should return something like:
```
(list (channel
        (name 'anthonyquizon-packages)
        (url "https://github.com/anthonyquizon/guix-channel.git")
        (commit
          "aa91d5b0392989be9eae2a94bf1a459cea357163"))
      (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (commit
          "ed248424d87e8df28583aa820569669db83a80be")))
```

if not, make sure the guix paths are correct:

```
export GUIX_PATH="$HOME/.config/guix/current/bin"
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
export GUIX_PROFILE="$HOME/.guix-profile"
export GUIX_INCLUDE_PATH="$HOME/.guix-profile/lib/locale"
export GUIX_LIBRARY_PATH="$HOME/.guix-profile/lib"

source "$GUIX_PROFILE/etc/profile"

export PATH="$GUIX_PATH:$PATH"
export INFOPATH="$HOME/.config/guix/current/share/info:$INFOPATH"

```
