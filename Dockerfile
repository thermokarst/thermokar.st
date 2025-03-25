FROM nginx:stable

RUN apt-get update && apt-get install -y \
    pandoc \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/markdown

COPY *.md /app/markdown
COPY *.md /usr/share/nginx/html
COPY template.html /app/markdown

COPY default.conf /etc/nginx/conf.d

RUN for md_file in /app/markdown/*.md; do \
    if [ -f "$md_file" ]; then \
        filename=$(basename -- "$md_file"); \
        name="${filename%.*}"; \
        echo "Converting $filename to $name.html"; \
        pandoc "$md_file" -o "/usr/share/nginx/html/$name.html" \
        --template=/app/markdown/template.html \
        --standalone; \
    fi; \
done

EXPOSE 80