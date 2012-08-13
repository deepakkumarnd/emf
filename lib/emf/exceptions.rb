module Emf
    module Exceptions
        class OptionNotFoundError < StandardError
            def message; "Error: Option should be given for details run emf --help" end
        end

        class DuplicateDirectoryError < StandardError
            def message; "Error: Directory already exists" end
        end

        class InvalidPathError < StandardError
            def message; "Error: Wrong path" end
        end
    end
end
