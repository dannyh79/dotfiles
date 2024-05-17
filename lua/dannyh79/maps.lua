local keymap = vim.keymap

-- Ignore arrow keys in Vim
keymap.set('n', '<up>', '<Nop>')
keymap.set('n', '<down>', '<Nop>')
keymap.set('n', '<left>', '<Nop>')
keymap.set('n', '<right>', '<Nop>')

-- Break line with capital K
keymap.set('n', 'K', 'i<CR><Esc>')

-- Open new file vertically
keymap.set('n', '<C-w>N', ':vnew<CR>')

-- Tab to indent by 1
keymap.set('n', '<Tab>', 'v>')
keymap.set('v', '<Tab>', '>gv')

-- Shift-Tab to remove indent by 1
keymap.set('n', '<S-Tab>', 'v<')
keymap.set('v', '<S-Tab>', '<gv')

-- 20200425 Copy current filepath
-- https://stackoverflow.com/posts/17096082/revisions
-- relative path (src/foo.txt)
keymap.set('n', '<leader>cfr', ":let @+=expand('%')<CR>")

-- absolute path (/something/src/foo.txt)
keymap.set('n', '<leader>cfa', ":let @+=expand('%:p')<CR>")

-- filename (foo.txt)
keymap.set('n', '<leader>cff', ":let @+=expand('%:t')<CR>")

-- directory name (/something/src)
keymap.set('n', '<leader>cfd', ":let @+=expand('%:p:h')<CR>")

-- :ymd to print out current time
keymap.set('i', ':ymd', '<C-R>=strftime("%Y-%m-%d %H:%M:%S %z")<CR>')
