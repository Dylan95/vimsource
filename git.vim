
"example workflow:
"GitCreate
"*change stuff
"GitSnapshot
"*create remote repository
"GitAddOrigin(url)
"GitSetRemote ...
"GitPush
"*change stuff
"GitSnapshot
"*change stuff
"GitSnapshot
"GitBranch ...
"*do a bunch of snapshots
"*realize you made a mistake and want to go back to the 3rd commit of b1
"GitRevert(3, b2)

"files -> local repository:

"returns the name of the current branch"
"the sed command removes "ref: refs/heads/" from the output of .git/HEAD
"leaving only the name of the current branch
function Git_branchName()
	return(ExecReturn('cat .git/HEAD | sed s/.*heads\\///'))
endfunction

"returns the number of commits from the root of the tree to HEAD
function Git_commitNum()
	let result = ExecReturn('git rev-list --count HEAD')
	return(substitute(l:result, "\n", "", "g"))
endfunction

function Git_MakeRevisionTag(branch, commitNumber)
	let result = "'(" . a:branch . ").(" . a:commitNumber . ")'"
	return(substitute(l:result, "\n", "", "g"))
endfunction



"creates a git folder for the current directory
function GitCreate()
	if isdirectory("./.git")
		echo "a git directory already exists."
	else
		call ExecNorm("git init")
		call ExecNorm("git add .")
		call ExecNorm("git commit -m 'initial commit'")
	endif
endfunction

"function GitAddAll()
"	silent exec "git add ."
"endfunction

function GitUpdate()
	call ExecNorm("git add .")
	call ExecNorm("git add -u .")
endfunction

function GitSnapshotM(message)
	let tagname = Git_MakeRevisionTag(Git_branchName(), Git_commitNum())
	call GitUpdate()
	"delete the tag in case it already exists.  In most cases it doesn't
	"exist and will cause an error, so I'm using 'silent!'
	call system("git tag --delete " . shellescape(l:tagname))
	call ExecNorm("git tag " . shellescape(l:tagname))
	call ExecNorm("git commit -m '" . shellescape(a:message) . "'")
endfunction
"
function GitSnapshot()
	call GitSnapshotM("no message")
endfunction

"remove files from index (memory).  
"Usefull for when .gitignore has been modified to remove more files.
"function GitRemove()
"	silent exec "git rm -r -f --cached"
"endfunction
"use this after you modified .gitignore
"function GitRefresh()
"	call GitRemove()
"	call GitSnapshot()
"endfunction

"local repository -> server repository:

"server repository can't be created with git CLI
"easyest way is just to go to the website and create it there

function GitAddOriginRemote(url)
	call ExecNorm("git remote add origin " . shellescape(a:url))
endfunction

"set the remote repository
function GitSetRemote(url)
	call ExecNorm("git remote set-url origin " . shellescape(a:url))
	"verify remote URL, just shows where it will fetch from and push to.
	"call ExecNorm("git remote -v")
endfunction

"origin is an alias for the remote server
"head is used to identify the current branch in this case
"--follow-tags flag: pushes the tags as well
function GitPush()
	call ExecNorm("git push --follow-tags origin HEAD")
endfunction
function GitPushForce()
	call ExecNorm("git push --follow-tags --force origin HEAD")
endfunction

function GitPull()
	call ExecNorm("git pull origin HEAD")
endfunction
function GitPullForce()
	call ExecNorm("git pull --force origin HEAD")
endfunction


"git output

function GitShowStatus()
	call ExecNorm("git status")
endfunction

function GitShowTree()
	"git log --graph --pretty=oneline --abbrev-commit
	call ExecNorm("git log --graph --abbrev-commit --decorate --date=relative --all")
	"silent exec "git branch"
	"silent exec "gitg -all"
endfunction

function GitShowList()
	call ExecNorm("git branch")
	call ExecNorm("git show-branch --all")
endfunction



"misc

"function GitSetEmail(email)
"	silent exec "git config --global user.email " . a:email
"endfunction

"note: Dylan95 for github, Dylan_95 for bitbucket
"function GitSetUsername(username)
"	silent exec "git config --global user.name " . a:username
"endfunction




"branching and loading

"create new branch
function GitBranch(newBranchName)
	call ExecNorm("git checkout -b " . shellescape(a:newBranchName))
endfunction

"change branch
function GitCheckout(branchName)
	call ExecNorm("git checkout " . shellescape(a:branchName))
endfunction

"commitNum: the commit number to return to.
"returning to this commit causes git to enter a 'detached head state'
"this means that if you want to make changes, you should call GitBranch,
"or call GitCheckout with another branch.
function GitRevert(commitNum)
	call ExecNorm("git checkout tags/" . Git_MakeRevisionTag(Git_branchName(), a:commitNum))
endfunction



"mappings:

"nnoremap <F8> :echo "git usage: F8: info, F9: snapshot, F10: branch/checkout/revert, F11: push, F12: pull"
"nnoremap <S-F8> :call GitShowList()
"nnoremap <A-F8> :call GitShowTree()

"nnoremap <F9> :call GitSnapshot('"I don't care about commit messages"')
"nnoremap <S-F9> :call GitSnapshot('"

"nnoremap <F10> :call GitBranch(
"nnoremap <S-F10> :call GitCheckout( 
"nnoremap <A-F10> :call GitRevert(

"nnoremap <F11> :call GitPush()
"nnoremap <S-F11> :call GitPushForce()

"nnoremap <F12> :call GitPull()
"nnoremap <S-F12> :call GitPullForce()










"track files (memory)
"map <F9> :call DCG_gitAddAll()

"commit files to local repository (disk)
"map <F10> :!git commit -m "I don't care about commit messages"<CR>

"push files to remote repository (server).  Password must be entered.
"map <F11> :!git push<CR>




