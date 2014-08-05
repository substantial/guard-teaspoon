module Guard
  class Teaspoon
    class Runner

      attr_accessor :console

      def initialize(options = {})
        @options = options

        begin
          require "teaspoon/console"
          @console = ::Teaspoon::Console.new(@options)
        rescue ::Teaspoon::EnvironmentNotFound => e
          STDOUT.print "Unable to load Teaspoon environment in {#{::Teaspoon::Environment.standard_environments.join(', ')}}.\n"
          STDOUT.print "Consider using -r path/to/teaspoon_env\n"
          abort
        end
      end

      def run_all(options = {})
        begin
          @console.execute(@options.merge(options))
        rescue Exception
          STDOUT.print "Teaspoon-guard: ERROR running all, probably a js/coffeescript syntax error.\n"
        end
      end

      def run(files = [], options = {})
        return false if files.empty?

        begin
          @console.execute(@options.merge(options).merge(files: files))
        rescue Exception
          STDOUT.print "Teaspoon-guard: ERROR running files #{files}.  Probably js/coffeescript syntax error.\n"
        end
      end

      private

      def abort
        exit(1)
      end
    end
  end
end
