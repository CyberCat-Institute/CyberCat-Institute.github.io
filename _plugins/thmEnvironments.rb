module Jekyll

    require 'json'

    class DefEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"definition\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class NotEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"notation\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class ExEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"example\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class DiagEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"diagram\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class PropEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"proposition\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class LemEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"lemma\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class ThmEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"theorem\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end

    class CorEnvironment < Liquid::Block
        def initialize(tag_name, input, tokens)
            super
            @input = input
        end
        def render(context)
            id = ""    
            text = super
            begin
                if( !@input.nil? && !@input.empty? )
                jdata = JSON.parse(@input)
                if( jdata.key?("id") )
                    id = jdata["id"].strip
                end
                end
            rescue
            end
            output =  "<div class=\"corollary\" markdown=\"1\" id=\"#{id}\">"        
            output += "#{text}"
            output += "</div>"
            return output;
        end
    end
    
    Liquid::Template.register_tag('def', Jekyll::DefEnvironment)
    Liquid::Template.register_tag('not', Jekyll::NotEnvironment)
    Liquid::Template.register_tag('ex', Jekyll::ExEnvironment)
    Liquid::Template.register_tag('diag', Jekyll::DiagEnvironment)
    Liquid::Template.register_tag('prop', Jekyll::PropEnvironment)
    Liquid::Template.register_tag('lem', Jekyll::LemEnvironment)
    Liquid::Template.register_tag('thm', Jekyll::ThmEnvironment)
    Liquid::Template.register_tag('cor', Jekyll::CorEnvironment)
end