<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RedirectToHttps
{
    /**
     * Redirect any non-HTTPS request to HTTPS.
     */
    public function handle(Request $request, Closure $next)
    {
        if (! $request->secure()) {
            return redirect()->secure($request->getRequestUri());
        }

        return $next($request);
    }
}
