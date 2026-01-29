# Báo Cáo Hệ Thống Cơ Sở Dữ Liệu - Quản Lý Thư Viện

Library Management Database System - Course Project Report for DBI202 at FPT University.

## Project Overview

This is a comprehensive LaTeX report for the Database Systems course (DBI202) that covers the design and implementation of a Library Management Database System. The report includes:


## Team Information

**Class:** SE2043 - Database Systems (DBI202)
**Group:** 3
**Instructor:** TS. Vũ Thanh Phong
**Institution:** FPT University

**Team Members:**
1. Nguyễn Ngọc Phúc
2. Thân Nhật Huy
3. Võ Hoàng Đình Trường
4. Nguyễn Thành An
5. Nguyễn Quang Thiên Phú
6. Phạm Ngọc Hưng

## Project Structure

```
report-dbi/
|-- latex/                      # Main LaTeX source files
|   |-- main.tex               # Main document file
|   |-- run.cmd                # Simple build script
|   |-- auto_build.bat         # Auto-build script (watch mode)
|   |-- images/                # Images and diagrams
|   |   |-- logo.png
|   |   |-- Library_Management_ERD_hinhthoi.drawio.png
|   |   |-- erd_diagram.pdf
|   |   `-- erd_diagram.svg
|   |-- main.pdf               # Compiled output
|   |-- main.aux               # Auxiliary files
|   |-- main.log
|   |-- main.out
|   `-- main.toc
|
|-- thu vien latex/            # LaTeX packages library
|   `-- tex-er-diagram/        # Custom ER diagram package
|       |-- er-diagram.sty
|       |-- examples/
|       `-- README.md
|
|-- tai lieu/                  # Reference documents
|   |-- report template.pdf
|   |-- report template.docx
|   `-- report template.sql
|
|-- submit_report1/            # Submission folder
|   `-- main.docx
|
|-- .gitignore                 # Git ignore rules
`-- README.md                  # This file
```

## Prerequisites & Environment Setup

### Required Software

1. **TeX Distribution** (install one of the following):
   - **MiKTeX** (Recommended for Windows)
     - Download: https://miktex.org/download
     - During installation, ensure **XeLaTeX** compiler is included
   - **TeX Live** (Cross-platform)
     - Download: https://www.tug.org/texlive/acquire-netinstall.html

2. **PDF Viewer** (with synctex support for forward/backward search):
   - SumatraPDF (Recommended for Windows) - https://www.sumatrapdfreader.org/
   - Okular (Cross-platform) - https://okular.kde.org/
   - TeXShop (macOS)

3. **Text Editor / IDE** (choose one):
   - VS Code with LaTeX Workshop extension
   - TeXstudio
   - Overleaf (Online)

### Required LaTeX Packages

The project uses the following packages (mostly included in standard distributions):

```latex
- fontspec       % For font selection in XeLaTeX
- xunicode       % Unicode support
- xltxtra        % Extra XeLaTeX features
- babel          % Language support (vietnamese)
- tikz           % Drawing diagrams
- svg            % SVG image support
- geometry       % Page layout
- hyperref       % PDF hyperlinks
- booktabs       % Professional tables
```

### Vietnamese Font Support

The document requires these fonts (usually pre-installed on Windows):
- **Times New Roman** (Main font)
- **Arial** (Sans-serif font)
- **Courier New** (Monospace font)

These are standard Windows fonts. On Linux, you may need to install Microsoft fonts or configure alternative fonts in `main.tex`.

## How to Compile

### Method 1: Using the Provided Build Scripts

**Quick Build (run.cmd):**
```cmd
cd latex
run.cmd
```

This will:
1. Run XeLaTeX first pass
2. Run XeLaTeX second pass (for table of contents and references)
3. Keep the window open for log review

**Auto-Build (auto_build.bat):**
```cmd
cd latex
auto_build.bat
```

This runs in **watch mode** - it automatically recompiles when you save `main.tex`.

### Method 2: Manual Command Line

**Navigate to the latex directory:**
```bash
cd latex
```

**Compile with XeLaTeX (run twice for proper references):**
```bash
xelatex -interaction=nonstopmode -synctex=1 main.tex
xelatex -interaction=nonstopmode -synctex=1 main.tex
```

**Explanation of flags:**
- `-interaction=nonstopmode` - Don't stop on errors (useful for batch compilation)
- `-synctex=1` - Enable SyncTeX for forward/backward search between PDF and source

### Method 3: Using VS Code

1. Install the **LaTeX Workshop** extension
2. Open `latex/main.tex`
3. Press `Ctrl+Alt+B` or click the "Build LaTeX project" button
4. The extension will auto-detect it needs XeLaTeX (from the magic comment on line 1)

### Method 4: Using TeXstudio

1. Open `latex/main.tex`
2. Configure Build > Default Compiler: **XeLaTeX**
3. Click Build or press `F5`

## Output

After successful compilation, the PDF will be generated at:
```
latex/main.pdf
```

## Document Contents

### Section 0: Introduction (Giới Thiệu Tổng Quan)
- Context and problem analysis
- Functional requirements
- Project scope and tools

### Section 1: Report 1 - Decomposition (Báo Cáo 1: Phân Rã)
- Task assignment matrix
- Theoretical foundation
- Entity definitions (6 entities):
  - **BOOK** - Book catalog
  - **AUTHOR** - Author information
  - **PUBLISHER** - Publisher details
  - **BOOK_COPY** - Physical book copies
  - **MEMBER** - Library members
  - **LOAN** - Borrow/return transactions
- Relationship mappings (5 relationships)
- ERD diagram

### Key Features
- **Vietnamese language support** using `babel` package with XeLaTeX
- **Custom title page** with decorative frame
- **Professional table formatting** using `booktabs`
- **ER diagrams** embedded as images
- **Hyperlinked table of contents**
- **Team member contribution matrix**

## Troubleshooting

### Issue: "Cannot find font Times New Roman"
**Solution:** The fonts need to be installed on your system. On Windows, they are pre-installed. On Linux, install:
```bash
sudo apt-get install fonts-liberation
```
Or change the fonts in `main.tex` lines 23-25.

### Issue: "Package babel error: Unknown language 'vietnamese'"
**Solution:** Ensure you have a complete TeX distribution. Update packages:
```bash
# MiKTeX
mpm --update-db

# TeX Live
tlmgr update --all
```

### Issue: PDF not updating after compilation
**Solution:** Delete auxiliary files and recompile:
```bash
cd latex
del *.aux *.log *.out *.toc *.synctex.gz
xelatex main.tex
xelatex main.tex
```

### Issue: Images not found
**Solution:** Ensure all image files are in `latex/images/` directory. Check the image paths in `main.tex`.

## Additional Resources

### ER Diagram Package
The project includes a custom ER diagram package in `thu vien latex/tex-er-diagram/`. To use it in other projects:
1. Copy `er-diagram.sty` to your project
2. Add `\usepackage{er-diagram}` to your preamble
3. See `examples/` for usage patterns

### Templates
Reference templates are available in the `tai lieu/` directory.

## License

This project is for educational purposes for the DBI202 course at FPT University.

## Contact

For questions or issues, please contact the team members or the course instructor.

---

**Last Updated:** January 2026
