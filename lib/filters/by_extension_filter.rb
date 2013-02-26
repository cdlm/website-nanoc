# -*- encoding : utf-8 -*-

class ByExtension < Nanoc::Filter
    identifier :by_extension
    type :text

    def run(content, params={})
        filter_id, options = assigns[:layout][:filter] || assigns[:layout][:extension]
        filter_id = filter_id.to_sym

        filter = Nanoc::Filter.named(filter_id)
        if filter.nil? or filter.from_binary? or filter.to_binary?
            raise Nanoc::Errors::CannotDetermineFilter.new(filter_id)
        end

        filter.new(@assigns).setup_and_run(content, params.fetch(filter_id, {}).merge(options || {}))
    end

end
