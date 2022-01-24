

"""
    plotDSM(DSM,label)

Plot the binary DSM.


# Arguments
- `DSM`: adjacency matrix.
- `label`: label for elements in this adjacency matrix.

# Examples

​```jldoctest
Julia> DSM = [0 1 0 0 0 1 0;
            0 0 0 1 0 0 0;
            1 0 0 0 0 0 1;
            0 0 0 0 1 0 0;
            0 1 0 0 0 1 0;
            0 0 1 0 0 0 0;
            1 0 0 0 1 0 0];
julia> label = ["A", "B", "C", "D", "E", "F", "G"];
julia> plotDSM(DSM,label)
"hugahuga"
```

"""

function plotDSM(DSM,label)
    (DSMr,DSMc) = size(DSM);

    @svg begin

        CellSizeRow = min(50,450/(DSMr+5));
        CellSizeColumn = min(50,450/(DSMc+5));
        t = Table(DSMr+1,DSMc+2, CellSizeRow, CellSizeColumn);

        sethue("black")

        for r in 2 : DSMr+1
            for c in 3 : DSMc+2
                box(t[r,c], t.colwidths[t.currentcol], t.rowheights[t.currentrow], :stroke);
                if r == c-1
                    sethue("grey")
                    box(t[r,c], t.colwidths[t.currentcol], t.rowheights[t.currentrow], :fill);
                    sethue("white")
                    fontsize(CellSizeColumn/2)
                    text(string(r-1), t[r,c] ,halign=:center, valign=:middle);
                    sethue("black")
                end

                if DSM[r-1,c-2] != 0
                    circle(t[r,c], CellSizeColumn/3, :fill)
                end
            end
        end

        for r in 1 : DSMr
            text(string(r), t[1,r+2] ,halign=:center, valign=:middle)
        end

        for c in 1 : DSMc
            text(string(c), t[c+1,2] ,halign=:center, valign=:middle)
        end

        for c in 1 : DSMc
            fontsize(min((CellSizeColumn/2)*(5/length(label[c])),CellSizeColumn/2))
            text(string(label[c]), t[c+1,1] ,halign=:right, valign=:middle)
        end


    end
end
