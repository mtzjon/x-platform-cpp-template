# Documentation configuration

find_package(Doxygen REQUIRED OPTIONAL_COMPONENTS dot)

if(DOXYGEN_FOUND)
    # Set Doxygen configuration variables
    set(DOXYGEN_PROJECT_NAME ${PROJECT_NAME})
    set(DOXYGEN_PROJECT_VERSION ${PROJECT_VERSION})
    set(DOXYGEN_PROJECT_DESCRIPTION ${PROJECT_DESCRIPTION})
    set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    set(DOXYGEN_HTML_OUTPUT html)
    set(DOXYGEN_LATEX_OUTPUT latex)
    
    # Input directories
    set(DOXYGEN_INPUT 
        ${CMAKE_SOURCE_DIR}/include 
        ${CMAKE_SOURCE_DIR}/src 
        ${CMAKE_SOURCE_DIR}/examples
        ${CMAKE_SOURCE_DIR}/README.md
    )
    
    # Configuration options
    set(DOXYGEN_RECURSIVE YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_EXTRACT_PRIVATE NO)
    set(DOXYGEN_EXTRACT_STATIC YES)
    set(DOXYGEN_HIDE_UNDOC_MEMBERS NO)
    set(DOXYGEN_HIDE_UNDOC_CLASSES NO)
    set(DOXYGEN_GENERATE_TREEVIEW YES)
    set(DOXYGEN_DISABLE_INDEX NO)
    set(DOXYGEN_FULL_SIDEBAR NO)
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE ${CMAKE_SOURCE_DIR}/README.md)
    
    # Source browser
    set(DOXYGEN_SOURCE_BROWSER YES)
    set(DOXYGEN_INLINE_SOURCES NO)
    set(DOXYGEN_STRIP_CODE_COMMENTS NO)
    
    # Cross-referencing
    set(DOXYGEN_REFERENCED_BY_RELATION YES)
    set(DOXYGEN_REFERENCES_RELATION YES)
    
    # Graph generation
    if(DOXYGEN_DOT_FOUND)
        set(DOXYGEN_HAVE_DOT YES)
        set(DOXYGEN_CALL_GRAPH YES)
        set(DOXYGEN_CALLER_GRAPH YES)
        set(DOXYGEN_COLLABORATION_GRAPH YES)
        set(DOXYGEN_INCLUDE_GRAPH YES)
        set(DOXYGEN_INCLUDED_BY_GRAPH YES)
        set(DOXYGEN_DIRECTORY_GRAPH YES)
        set(DOXYGEN_DOT_IMAGE_FORMAT svg)
        set(DOXYGEN_INTERACTIVE_SVG YES)
    endif()
    
    # LaTeX generation
    set(DOXYGEN_GENERATE_LATEX YES)
    set(DOXYGEN_LATEX_CMD_NAME pdflatex)
    set(DOXYGEN_USE_PDFLATEX YES)
    set(DOXYGEN_PDF_HYPERLINKS YES)
    
    # HTML customization
    set(DOXYGEN_HTML_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/header.html)
    set(DOXYGEN_HTML_FOOTER ${CMAKE_CURRENT_SOURCE_DIR}/footer.html)
    set(DOXYGEN_HTML_STYLESHEET ${CMAKE_CURRENT_SOURCE_DIR}/custom.css)
    set(DOXYGEN_HTML_COLORSTYLE_HUE 220)
    set(DOXYGEN_HTML_COLORSTYLE_SAT 100)
    set(DOXYGEN_HTML_COLORSTYLE_GAMMA 80)
    
    # File patterns
    set(DOXYGEN_FILE_PATTERNS 
        *.hpp *.h *.cpp *.cxx *.cc *.md *.dox
    )
    
    # Exclude patterns
    set(DOXYGEN_EXCLUDE_PATTERNS 
        */build/* 
        */cmake-build-*/* 
        */.git/*
        */tests/*
    )
    
    # Preprocessing
    set(DOXYGEN_ENABLE_PREPROCESSING YES)
    set(DOXYGEN_MACRO_EXPANSION YES)
    set(DOXYGEN_EXPAND_ONLY_PREDEF NO)
    set(DOXYGEN_SEARCH_INCLUDES YES)
    
    # Create Doxygen target
    doxygen_add_docs(docs
        ${DOXYGEN_INPUT}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Generating API documentation with Doxygen"
    )
    
    # Install documentation
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html/
        DESTINATION ${CMAKE_INSTALL_DOCDIR}/html
        OPTIONAL
    )
    
    if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/latex/refman.pdf)
        install(FILES ${CMAKE_CURRENT_BINARY_DIR}/latex/refman.pdf
            DESTINATION ${CMAKE_INSTALL_DOCDIR}
            RENAME ${PROJECT_NAME}-${PROJECT_VERSION}.pdf
            OPTIONAL
        )
    endif()
    
    # Custom target to build PDF documentation
    if(DOXYGEN_DOT_FOUND)
        find_program(PDFLATEX_FOUND pdflatex)
        if(PDFLATEX_FOUND)
            add_custom_target(docs-pdf
                COMMAND ${CMAKE_COMMAND} --build . --target docs
                COMMAND cd latex && ${PDFLATEX_FOUND} refman.tex
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                COMMENT "Building PDF documentation"
                DEPENDS docs
            )
        endif()
    endif()
    
else()
    message(WARNING "Doxygen not found. Documentation will not be built.")
endif()