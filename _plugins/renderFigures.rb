module Jekyll
    class RenderFigures < Liquid::Block
		def initialize(tag_name, input, tokens)
			super
			@input = input
		end
		def render(context)
			id = ""    
			text = super
			noCaption = "#{text}"
			output = noCaption
			begin
				if( !@input.nil? && !@input.empty? )
				jdata = JSON.parse(@input)
				if( jdata.key?("id") )
					id = jdata["id"].strip
                    output = "{:.figure}"
					output += noCaption
				end
				end
			rescue
			end
			return output;
		end
    end

	Liquid::Template.register_tag('figure', Jekyll::RenderFigures)
end