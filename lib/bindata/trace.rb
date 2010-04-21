module BinData
  # reference to the current tracer
  @tracer ||= nil

  class Tracer #:nodoc:
    def initialize(io)
      @trace_io = io
    end

    def trace(msg)
      @trace_io.puts(msg)
    end

    def trace_obj(obj_name, val)
      if val.length > 30
        val = val.slice(0 .. 30) + "..."
      end

      trace "#{obj_name} => #{val}"
    end
  end

  # Turn on trace information when reading a BinData object.
  # If +block+ is given then the tracing only occurs for that block.
  # This is useful for debugging a BinData declaration.
  def trace_reading(io = STDERR, &block)
    @tracer = Tracer.new(io)
    if block_given?
      begin
        block.call
      ensure
        @tracer = nil
      end
    end
  end

  def trace_message(&block) #:nodoc:
    yield @tracer if @tracer
  end

  module_function :trace_reading, :trace_message
end
