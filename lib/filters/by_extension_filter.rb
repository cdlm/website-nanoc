class ByExtension < Nanoc3::Filter
    identifier :by_extension
    type :text

    def run(content, params={})
        extension = assigns[:layout][:extension]
        actual_filter = Nanoc3::Filter.named(extension)
        if actual_filter.nil? or actual_filter.from_binary? or actual_filter.to_binary?
            raise Nanoc3::Errors::CannotDetermineFilter.new(extension)
        end

        actual_filter.new(@assigns).run(content, params)
    end

end

