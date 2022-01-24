

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
        t = Table(DSMr+1,DSMc+1, CellSizeRow, CellSizeColumn);

        sethue("black")

        for r in 2 : DSMr+1
            for c in 2 : DSMc+1
                box(t[r,c], t.colwidths[t.currentcol], t.rowheights[t.currentrow], :stroke);
                if r == c
                    sethue("grey")
                    box(t[r,c], t.colwidths[t.currentcol], t.rowheights[t.currentrow], :fill);
                    sethue("white")
                    textfit(label[r-1], BoundingBox(box(t[r,c],CellSizeRow, CellSizeColumn)))
                    sethue("black")
                end

                if DSM[r-1,c-1] != 0
                    circle(t[r,c], CellSizeColumn/3, :fill)
                end
            end
        end



        for r in 1 : DSMr
            textfit(label[r], BoundingBox(box(t[r+1,1],CellSizeRow, CellSizeColumn)))
        end

        for c in 1 : DSMc
            textfit(label[c], BoundingBox(box(t[1,c+1],CellSizeRow, CellSizeColumn)))
        end

    end
end
