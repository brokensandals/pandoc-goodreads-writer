local footnotes = {}

local scaffolded = pandoc.scaffolding.Writer

scaffolded.Block.BulletList = function (bl, opts)
  local result = ""
  for i, item in ipairs(bl.content) do
    result = result .. "- " .. scaffolded.Blocks(item)
  end
  return result
end

scaffolded.Block.BlockQuote = function (bq, opts)
  return {"<blockquote>", scaffolded.Blocks(bq.content), "</blockquote>"}
end

scaffolded.Inline.Cite = function (cite, opts)
  local result = {}
  for i, item in ipairs(cite.citations) do
    table.insert(result, "[" .. item.note_num .. "]")
    table.insert(footnotes, "[" .. item.note_num .. "] " .. scaffolded.Inline(cite.content[i]))
  end
  return result
end

scaffolded.Block.Div = function (div, opts)
  if div.identifier == "footnotes" then
    return footnotes
  elseif div.classes[1] == "spoiler" then
    return {"<spoiler>", scaffolded.Blocks(div.content), "</spoiler>"}
  else
    return scaffolded.Blocks(div.content)
  end
end

scaffolded.Inline.Emph = function (emph, opts)
  return {"<i>", scaffolded.Inlines(emph.content), "</i>"}
end

scaffolded.Block.Header = function (hdr, opts)
  return {"<b>", scaffolded.Inlines(hdr.content), "</b>"}
end

scaffolded.Inline.LineBreak = pandoc.layout.cr

scaffolded.Inline.Link = function (link, opts)
  -- TODO escaping; use title attribute
  return {"<a href=\"" .. link.target .. "\">", scaffolded.Inlines(link.content), "</a>"}
end

scaffolded.Inline.Note = function (note, opts)
  return scaffolded.Blocks(note.content)
end

scaffolded.Block.OrderedList = function (ol, opts)
  local result = {}
  for i, item in ipairs(ol.content) do
    table.insert(result, tostring(i) .. ". ")
    table.insert(result, scaffolded.Blocks(item))
  end
  return result
end

scaffolded.Block.Para = function (para, opts)
  return {scaffolded.Inlines(para.content), pandoc.layout.blankline}
end

scaffolded.Block.Plain = function (plain, opts)
  return {scaffolded.Inlines(plain.content), pandoc.layout.blankline}
end

scaffolded.Inline.Quoted = function (quoted, opts)
  local inner = scaffolded.Inlines(quoted.content)
  if quoted.quotetype == "DoubleQuote" then
    return {"&ldquo;", inner, "&rdquo;"}
  elseif quoted.quotetype == "SingleQuote" then
    return {"&lsquo;", inner, "&rsquo"}
  else
    error("unsupported quotetype " .. quoted.quotetype)
  end
end

scaffolded.Inline.SoftBreak = pandoc.layout.cr

scaffolded.Inline.Space = " "

scaffolded.Inline.Span = function (span, opts)
  -- Sometimes there are spans without any identifiers or classes, not sure why...
  if span.classes[1] == "spoiler" then
    return {"<spoiler>", scaffolded.Inlines(span.content), "</spoiler>"}
  else
    return scaffolded.Inlines(span.content)
  end
end

scaffolded.Inline.Str = function (str, opts)
  return str.text
end

scaffolded.Inline.Strong = function (strong, opts)
  return {"<b>", scaffolded.Inlines(strong.content), "</b>"}
end

Writer = function(doc, opts)
  table.insert(doc.blocks, pandoc.Div({}, {id="footnotes"}))
  return scaffolded(doc, opts)
end
