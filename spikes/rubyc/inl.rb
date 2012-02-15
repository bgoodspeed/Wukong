require "inline"


class MyInline
  inline do |builder|
    builder.include '<stdio.h>'
    builder.include '<math.h>'
    builder.add_compile_flags '-lm'    
    builder.c "     
      double the_cosine(double x) {
         return cos(x);
      }"
    builder.c "
      long factorial(int max) {
        int i=max, result=1;
        while (i >= 2) { result *= i--; }
        return result;
      }"
  end
end
#t = MyInline.new()
#factorial_5 = t.factorial(5)

#puts "5! = #{factorial_5}"
#puts "cos(1) = #{t.the_cosine(1)}"

