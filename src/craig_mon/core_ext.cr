struct NamedTuple
  def to_h
    {% if T.size == 0 %}
      {% raise "Can't convert an empty NamedTuple to a Hash" %}
    {% else %}
      {
        {% for key in T %}
          {{key.symbolize}} => self[{{key.symbolize}}].dup,
        {% end %}
      }
    {% end %}
  end
end
