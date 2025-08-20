import os
import ycm_core

# --- Python 相关配置 ---
VENV_NAMES = ['.venv', 'venv', '.env']

def FindVenv(filename):
    current_dir = os.path.dirname(os.path.abspath(filename))
    while True:
        for venv_name in VENV_NAMES:
            venv_path = os.path.join(current_dir, venv_name)
            interpreter_path = os.path.join(venv_path, 'bin', 'python')
            if os.path.exists(interpreter_path):
                return interpreter_path
        parent_dir = os.path.dirname(current_dir)
        if parent_dir == current_dir:
            break
        current_dir = parent_dir
    return None

def PythonSettings(filename):
    interpreter_path = FindVenv(filename)
    if interpreter_path:
        return {'interpreter_path': interpreter_path}
    return {'interpreter_path': '/opt/homebrew/bin/python3'} # <-- 默认 Python 3 路径

# --- C++ 相关配置 ---
SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']

def FindCompilationDatabase(filename):
    current_dir = os.path.dirname(os.path.abspath(filename))
    while True:
        db_path = os.path.join(current_dir, 'compile_commands.json')
        if os.path.exists(db_path):
            return ycm_core.CompilationDatabase(current_dir)
        parent_dir = os.path.dirname(current_dir)
        if parent_dir == current_dir:
            return None
        current_dir = parent_dir
    return None

def IsHeaderFile(filename):
    return os.path.splitext(filename)[1] in ['.h', '.hxx', '.hpp', '.hh']

def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os.path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                info = database.GetCompilationInfoForFile(replacement_file)
                if info.compiler_flags_:
                    return info
        return None
    return database.GetCompilationInfoForFile(filename)

def CppSettings(filename):
    database = FindCompilationDatabase(filename)
    if not database:
        return {
            'flags': ['-Wall', '-Wextra', '-std=c++17', '-x', 'c++', '-I', '.'],
        }
    
    compilation_info = GetCompilationInfoForFile(database, filename)
    if not compilation_info:
        return None

    return {
        'flags': list(compilation_info.compiler_flags_),
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
    }

# --- YCM 主入口函数 ---
def Settings(**kwargs):
    language = kwargs['language']
    filename = kwargs['filename']

    if language == 'python':
        return PythonSettings(filename)
    
    if language in ['cfamily', 'cpp', 'c']:
        return CppSettings(filename)
    
    return {}
