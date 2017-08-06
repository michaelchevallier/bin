# class='ruby /Users/USER/bin/class.rb' <- alias
# class "Toto#std::string_name,unsigned int_nbToto" "Toto2#bool_name,unsigned int_nbToto"
#

def make_cpp name, _attr = nil

	s = "#include \"#{name}.hpp\"\n\n"
	s << "// STATIC ########################################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// CANONICAL #####################################################\n\n"
	s << "#{name}::#{name} ( void )\n"
	s << "{\n"
	s << "	return ;\n"
	s << "}\n\n"
	s << "#{name}::#{name} ( #{name} const & src )\n"
	s << "{\n"
	s << "	*this = src;\n"
	s << "	return ;\n"
	s << "}\n\n"
	s << "#{name} &				#{name}::operator=( #{name} const & rhs )\n"
	s << "{\n"
	s << "	if (this != &rhs)\n"
	s << "	{\n"
	if _attr
		_attr.each do |a|
			v = a.split('_')
			s << "		this->_#{v.last} = rhs.get#{v.last.slice(0,1).capitalize + v.last.slice(1..-1)}();\n"
		end
	else
		s << "		// make stuff\n"
	end
	s << "	}\n"
	s << "	return (*this);\n"
	s << "}\n\n"
	s << "#{name}::~#{name} ( void )\n"
	s << "{\n"
	s << "	return ;\n"
	s << "}\n\n"
	s << "// ###############################################################\n\n"
	s << "// CONSTRUCTOR POLYMORPHISM ######################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// OVERLOAD OPERATOR #############################################\n\n"
	s << "std::ostream &				operator<<(std::ostream & o, #{name} const & i)\n{\n"
	s << "\t(void)i;\n\treturn (o);"
	s << "\n}\n\n// ###############################################################\n\n"
	s << "// PUBLIC METHOD #################################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// GETTER METHOD #################################################\n\n"
	if _attr
		_attr.each do |a|
			v = a.split('_')
			s << "#{v.first}		"
			s << "	" if v.first.length < 16
			s << "	" if v.first.length < 11
			s << "	" if v.first.length < 6
			s << "#{name}::get#{v.last.slice(0,1).capitalize + v.last.slice(1..-1)}( void ) const noexcept\n"
			s << "{\n"
			s << "	return(this->_#{v.last});\n"
			s << "}\n"
		end
		s << "\n"
	end
	s << "// ###############################################################\n\n"
	s << "// SETTER METHOD #################################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// PRIVATE METHOD ################################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// EXCEPTION METHOD ##############################################\n\n"
	s << "// ###############################################################\n\n"
	s << "// EXTERNAL ######################################################\n\n"
	s << "// ###############################################################\n"
	puts "create #{name}.cpp"
	s
end

def make_hpp name, _attr = nil

	s =  "// ------------------------------------------------------------	//\n"
	s << "//																//\n"
	s << "//																//\n"
	s << "// ------------------------------------------------------------	//\n\n"
	s << "#ifndef #{name.upcase}_HPP\n"
	s << "# define #{name.upcase}_HPP\n\n"
	s << "class #{name}\n"
	s << "{\n"
	s << "	public:\n"
	s << "	\n"
	s << "		#{name}( void );\n"
	s << "		#{name}( #{name} const & src );\n"
	s << "		virtual ~#{name}( void );\n\n"
	s << "		#{name} &							operator=( #{name} const & rhs );\n"
	s << "		friend std::ostream &				operator<<(std::ostream & o, #{name} const & i);\n\n"
	if _attr
		_attr.each do |a|
			v = a.split('_')
			s << "		#{v.first}	"
			s << "	" if v.first.length < 16
			s << "	" if v.first.length < 11
			s << "	" if v.first.length < 6
			s << "get#{v.last.slice(0,1).capitalize + v.last.slice(1..-1)}( void ) const noexcept;\n"
		end
	end
	s << "	\n"
	if _attr
		s << "	private:\n\n"
		_attr.each do |a|
			v = a.split('_')
			s << "		#{v.first}	"
			s << "	" if v.first.length < 16
			s << "	" if v.first.length < 11
			s << "	" if v.first.length < 6
			s << "_#{v.last};\n"
		end
	end
	s << "};\n\n"
	s << "#endif\n"
	puts "create #{name}.hpp"
	s
end

ARGV.each do |filename|
	f = filename.split('-') # -Class pour juste le .hpp
	g = f.last.split('#').last.split(',')
	f = f.last.split('#').first
	File.open("#{f}.hpp", 'w') { |file| file.write(make_hpp(f, (filename.split('#').count > 1) ? g : nil)) }
	File.open("#{f}.cpp", 'w') { |file| file.write(make_cpp(f, (filename.split('#').count > 1) ? g : nil)) } if filename.split('-').count == 1
end
