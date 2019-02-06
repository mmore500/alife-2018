# get the basename of the containing directory
# this will be used to name othe output document
BUILD_DIR := $(shell basename $(abspath $(dir $(lastword $(MAKEFILE_LIST)))))

all: ${BUILD_DIR}-draft.pdf

view:
	atom ${BUILD_DIR}.pdf

${BUILD_DIR}.pdf: main.tex
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR} \
    -pdflatex="pdflatex -interaction=nonstopmode" main.tex

${BUILD_DIR}-draft.pdf: main.tex
	latexmk -pdf -silent \
    -jobname=${BUILD_DIR}-draft \
    -pdflatex="pdflatex -interaction=nonstopmode" draft.tex

figure_appendix.pdf: figure_appendix.tex
	latexmk -pdf -silent \
		-jobname=figure_appendix \
		-pdflatex="pdflatex -interaction=nonstopmode" figure_appendix.tex

coverpage.pdf: coverpage.md
	pandoc coverpage.md -f commonmark -o coverpage.pdf

moreno.tex: main.tex
	perl latexpand.pl main.tex > moreno.tex

moreno.pdf: coverpage.pdf ${BUILD_DIR}.pdf figure_appendix.pdf
	pdftk coverpage.pdf ${BUILD_DIR}.pdf figure_appendix.pdf cat output moreno.pdf

moreno.tar.gz: moreno.pdf moreno.tex
	mkdir -p temp && \
	cp moreno.pdf temp && \
	cp moreno.tex temp && \
	pdftops img/explanatory.pdf temp/moreno.fig1.eps && \
	pdftops img/ChannelMap_1044_update20000000.pdf temp/moreno.fig2a.eps && \
 	pdftops img/ChannelMap_1016_update20000000.pdf temp/moreno.fig2b.eps && \
	pdftops img/ChannelMap_1007_update20000000.pdf temp/moreno.fig2c.eps && \
	pdftops img/ChannelMap_1007_update0.pdf temp/moreno.fig3a.eps && \
	pdftops img/ChannelMap_1007_update55520.pdf temp/moreno.fig3b.eps && \
	pdftops img/ChannelMap_1007_update277600.pdf temp/moreno.fig3c.eps && \
	pdftops img/ChannelMap_1007_update500000.pdf temp/moreno.fig3d.eps && \
	pdftops img/ChannelMap_1007_update1000000.pdf temp/moreno.fig3e.eps && \
	pdftops img/ChannelMap_1007_update2000000.pdf temp/moreno.fig3f.eps && \
	pdftops img/champion_res_pool1_vs_champion_damage_suicide0.pdf temp/moreno.fig4a.eps && \
	pdftops img/champion_res_pool2_vs_champion_damage_suicide0.pdf temp/moreno.fig4b.eps && \
	pdftops img/ChannelMap_1030_update0.pdf temp/moreno.fig5a.eps && \
	pdftops img/ChannelMap_1030_update5552.pdf temp/moreno.fig5b.eps && \
	pdftops img/ChannelMap_1030_update11104.pdf temp/moreno.fig5c.eps && \
	pdftops img/ChannelMap_1030_update22208.pdf temp/moreno.fig5d.eps && \
	pdftops img/ChannelMap_1030_update55520.pdf temp/moreno.fig5e.eps && \
	pdftops img/ChannelMap_1030_update1500000.pdf temp/moreno.fig5f.eps && \
	pdftops img/mean_res_pool1_vs_net_reproduction.pdf temp/moreno.fig6a.eps && \
	pdftops img/mean_res_pool2_vs_net_reproduction.pdf temp/moreno.fig6b.eps && \
	pdftops img/ChannelMap_1018_update3000000.pdf temp/moreno.fig7.eps && \
	cp bibl.bib temp/moreno.bib && \
	tar -cvzf moreno.tar.gz temp && \
	rm -r temp

clean:
	rm -f ${BUILD_DIR}.pdf
	rm -f ${BUILD_DIR}-draft.pdf

cleaner:
	latexmk -CA
	# remove auxillary files, excepting .tex and .bib files
	find . -type f -name ${BUILD_DIR}"*" ! -name '*.tex' ! -name '*.bib' -delete
	rm -f coverpage.pdf
	rm -f moreno.pdf
	rm -f coverpage.pdf
	rm -f moreno.tar.gz
	rm -f moreno.tex
