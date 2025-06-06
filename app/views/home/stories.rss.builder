xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title Rails.application.name + (@title.present? ? ": #{@title}" : "")
    xml.link Rails.application.root_url
    xml.tag! "atom:link", nil, href: request.original_url, rel: :self
    xml.description @title
    xml.pubDate @stories.first.created_at.rfc822 if @stories.any?
    xml.ttl 120

    @stories.each do |story|
      xml.item do
        xml.title story.title
        xml.link Routes.url_or_comments_url(story)
        xml.guid Routes.story_short_id_url(story)
        xml.author "#{story.domain&.domain} #{story.user_is_author? ? "by" : "via"} #{story.user.username}"
        xml.pubDate story.created_at.rfc822
        xml.comments Routes.title_url(story)
        description = story.markeddown_description.to_s
        if story.url.present?
          description += "<p>#{link_to("Comments", Routes.title_url(story))}</p>"
        end
        xml.description description
        story.taggings.each do |tagging|
          xml.category tagging.tag.tag
        end
      end
    end
  end
end
