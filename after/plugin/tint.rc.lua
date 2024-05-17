local status, shade = pcall(require, "tint")
if (not status) then return end

shade.setup {
  tint = -50,
  tint_background_colors = false
}
