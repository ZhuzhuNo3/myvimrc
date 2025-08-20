#!/bin/bash

# --- Script Configuration ---
# 脚本出错时立即退出
set -e

# --- Style and Formatting ---
# 定义颜色代码以便输出更美观
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Helper Functions ---
# 打印信息
info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

# 打印警告
warn() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

# 打印成功信息
success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

# 脚本主目录 (无论从哪里执行，都能找到源文件)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
HOME_DIR="$HOME"

# --- Main Logic ---

# 1. 自动安装 vim-plug (如果不存在)
PLUG_VIM="$HOME_DIR/.vim/autoload/plug.vim"
if [ ! -f "$PLUG_VIM" ]; then
    info "vim-plug not found. Installing it now..."
    curl -fLo "$PLUG_VIM" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    success "vim-plug installed successfully."
else
    info "vim-plug is already installed."
fi

# 2. 处理配置文件软链接
CONFIG_FILES=("vimrc" "ycm_extra_conf.py")

info "Setting up configuration files..."
for file in "${CONFIG_FILES[@]}"; do
    SOURCE_PATH="$SCRIPT_DIR/$file"
    DEST_PATH="$HOME_DIR/.$file"

    # 检查源文件是否存在
    if [ ! -f "$SOURCE_PATH" ]; then
        warn "Source file '$file' not found in script directory. Skipping."
        continue
    fi

    # 如果目标位置存在，则处理冲突
    if [ -e "$DEST_PATH" ]; then
        # 如果是软链接，强制删除
        if [ -L "$DEST_PATH" ]; then
            info "Removing existing symlink at '$DEST_PATH'."
            rm -f "$DEST_PATH"
        # 如果是普通文件，则备份
        elif [ -f "$DEST_PATH" ]; then
            warn "Existing file found at '$DEST_PATH'. Backing it up to '$DEST_PATH.bak'."
            mv "$DEST_PATH" "$DEST_PATH.bak"
        # 如果是目录，则报错退出
        elif [ -d "$DEST_PATH" ]; then
            warn "A directory exists at '$DEST_PATH'. Cannot create symlink. Please remove it manually."
            exit 1
        fi
    fi

    # 创建新的软链接
    info "Creating symlink for '$file' -> '$DEST_PATH'."
    ln -s "$SOURCE_PATH" "$DEST_PATH"
done
success "Configuration files linked successfully."

# 3. 安装颜色主题
COLOR_SCHEME_FILE="Tomorrow-Night.vim"
VIM_COLORS_DIR="$HOME_DIR/.vim/colors"

info "Installing color scheme '$COLOR_SCHEME_FILE'..."
if [ ! -f "$SCRIPT_DIR/$COLOR_SCHEME_FILE" ]; then
    warn "Color scheme file '$COLOR_SCHEME_FILE' not found. Skipping."
else
    # 创建目录 (如果不存在)
    mkdir -p "$VIM_COLORS_DIR"
    # 复制文件
    cp "$SCRIPT_DIR/$COLOR_SCHEME_FILE" "$VIM_COLORS_DIR/"
    success "Color scheme installed to '$VIM_COLORS_DIR'."
fi


# 4. 提示安装字体
info "--------------------------------------------------------"
info "FONT INSTALLATION NOTICE:"
info "This script does not automatically install fonts."
info "For the best experience, please manually install:"
info "1. A Nerd Font (e.g., UbuntuMono Nerd Font) for icons and symbols."
info "   - Visit: https://www.nerdfonts.com/"
info "2. After installation, set your terminal to use this font."
info "vim-airline themes often rely on Powerline symbols, which are included in all Nerd Fonts."
info "--------------------------------------------------------"


# 5. 安装 Vim 插件
info "Installing Vim plugins using vim-plug..."
# 使用 -es 和 +qa 标志让 vim 在后台自动执行，无需用户交互
vim -es -u "$HOME_DIR/.vimrc" +PlugInstall +qa
success "Plugin installation process completed."

# --- Final Message ---
printf "\n${GREEN}===============================================${NC}\n"
success "Vim environment setup is complete!"
printf "${GREEN}===============================================${NC}\n"
info "Please restart your terminal or open a new one for all changes to take effect."