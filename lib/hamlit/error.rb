module Hamlit
  class Error < Exception
  end

  class SyntaxError < Exception
  end

  class InternalError < RuntimeError
  end
end
