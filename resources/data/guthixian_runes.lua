

local M = {}

function M.CreateSprites(parent)
    if not parent then
        log("CreateSprites: parent is nil")
        return nil
    end

    local guthixian_runes = {
        A = Plugin.resources.sprites.utility.guthixian_runes.a,
        B = Plugin.resources.sprites.utility.guthixian_runes.b,
        C = Plugin.resources.sprites.utility.guthixian_runes.c,
        D = Plugin.resources.sprites.utility.guthixian_runes.d,
        E = Plugin.resources.sprites.utility.guthixian_runes.e,
        F = Plugin.resources.sprites.utility.guthixian_runes.f,
        G = Plugin.resources.sprites.utility.guthixian_runes.g,
        H = Plugin.resources.sprites.utility.guthixian_runes.h,
        I = Plugin.resources.sprites.utility.guthixian_runes.i,
        J = Plugin.resources.sprites.utility.guthixian_runes.j,
        K = Plugin.resources.sprites.utility.guthixian_runes.k,
        L = Plugin.resources.sprites.utility.guthixian_runes.l,
        M = Plugin.resources.sprites.utility.guthixian_runes.m,
        N = Plugin.resources.sprites.utility.guthixian_runes.n,
        O = Plugin.resources.sprites.utility.guthixian_runes.o,
        P = Plugin.resources.sprites.utility.guthixian_runes.p,
        Q = Plugin.resources.sprites.utility.guthixian_runes.q,
        R = Plugin.resources.sprites.utility.guthixian_runes.r,
        S = Plugin.resources.sprites.utility.guthixian_runes.s,
        T = Plugin.resources.sprites.utility.guthixian_runes.t,
        U = Plugin.resources.sprites.utility.guthixian_runes.u,
        V = Plugin.resources.sprites.utility.guthixian_runes.v,
        W = Plugin.resources.sprites.utility.guthixian_runes.w,
        X = Plugin.resources.sprites.utility.guthixian_runes.x,
        Y = Plugin.resources.sprites.utility.guthixian_runes.y,
        Z = Plugin.resources.sprites.utility.guthixian_runes.z,
    }

    return guthixian_runes
end

return M

